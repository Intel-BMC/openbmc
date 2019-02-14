#include "ikvm_server.hpp"

#include <rfb/rfbproto.h>

#include <phosphor-logging/elog-errors.hpp>
#include <phosphor-logging/elog.hpp>
#include <phosphor-logging/log.hpp>
#include <xyz/openbmc_project/Common/error.hpp>

namespace ikvm
{

using namespace phosphor::logging;
using namespace sdbusplus::xyz::openbmc_project::Common::Error;

Server::Server(const Args& args, Input& i, Video& v) :
    pendingResize(false), frameCounter(0), numClients(0), input(i), video(v)
{
    std::string ip("localhost");
    const Args::CommandLine& commandLine = args.getCommandLine();
    int argc = commandLine.argc;

    server = rfbGetScreen(&argc, commandLine.argv, video.getWidth(),
                          video.getHeight(), Video::bitsPerSample,
                          Video::samplesPerPixel, Video::bytesPerPixel);

    if (!server)
    {
        log<level::ERR>("Failed to get VNC screen due to invalid arguments");
        elog<InvalidArgument>(
            xyz::openbmc_project::Common::InvalidArgument::ARGUMENT_NAME(""),
            xyz::openbmc_project::Common::InvalidArgument::ARGUMENT_VALUE(""));
    }

    framebuffer.resize(
        video.getHeight() * video.getWidth() * Video::bytesPerPixel, 0);

    server->screenData = this;
    server->desktopName = "OpenBMC IKVM";
    server->alwaysShared = true;
    server->frameBuffer = framebuffer.data();
    server->newClientHook = newClient;
    server->cursor = rfbMakeXCursor(cursorWidth, cursorHeight, (char*)cursor,
                                    (char*)cursorMask);
    server->cursor->xhot = 1;
    server->cursor->yhot = 1;
    // char httpDir[] = "../webclients";
    // server->httpDir = httpDir;
    // server->httpEnableProxyConnect = true;

    // commented it out to allow OOB connection
    // rfbStringToAddr(&ip[0], &server->listenInterface);

    rfbInitServer(server);

    rfbMarkRectAsModified(server, 0, 0, video.getWidth(), video.getHeight());

    server->kbdAddEvent = Input::keyEvent;
    server->ptrAddEvent = Input::pointerEvent;

    processTime = (1000000 / video.getFrameRate()) - 100;
}

Server::~Server()
{
    rfbScreenCleanup(server);
}

void Server::resize()
{
    if (frameCounter > video.getFrameRate())
    {
        doResize();
    }
    else
    {
        pendingResize = true;
    }
}

void Server::run()
{
    rfbProcessEvents(server, processTime);

    if (server->clientHead)
    {
        input.sendReport();

        frameCounter++;
        if (pendingResize && frameCounter > video.getFrameRate())
        {
            doResize();
            pendingResize = false;
        }
    }
}

void Server::sendFrame()
{
    char* data = video.getData();
    rfbClientIteratorPtr it;
    rfbClientPtr cl;

    if (!data || pendingResize)
    {
        return;
    }

    it = rfbGetClientIterator(server);

    while ((cl = rfbClientIteratorNext(it)))
    {
        ClientData* cd = (ClientData*)cl->clientData;
        rfbFramebufferUpdateMsg* fu = (rfbFramebufferUpdateMsg*)cl->updateBuf;

        if (!cd)
        {
            continue;
        }

        if (cd->skipFrame)
        {
            cd->skipFrame--;
            continue;
        }

        if (cl->enableLastRectEncoding)
        {
            fu->nRects = 0xFFFF;
        }
        else
        {
            fu->nRects = Swap16IfLE(1);
        }

        fu->type = rfbFramebufferUpdate;
        cl->ublen = sz_rfbFramebufferUpdateMsg;
        rfbSendUpdateBuf(cl);

        cl->tightEncoding = rfbEncodingTight;
        rfbSendTightHeader(cl, 0, 0, video.getWidth(), video.getHeight());

        cl->updateBuf[cl->ublen++] = (char)(rfbTightJpeg << 4);
        rfbSendCompressedDataTight(cl, data, video.getFrameSize());

        if (cl->enableLastRectEncoding)
        {
            rfbSendLastRectMarker(cl);
        }

        rfbSendUpdateBuf(cl);
    }

    rfbReleaseClientIterator(it);
}

void Server::clientGone(rfbClientPtr cl)
{
    Server* server = (Server*)cl->screen->screenData;

    delete (ClientData*)cl->clientData;

    if (server->numClients-- == 1)
    {
        rfbMarkRectAsModified(server->server, 0, 0, server->video.getWidth(),
                              server->video.getHeight());
    }
}

enum rfbNewClientAction Server::newClient(rfbClientPtr cl)
{
    Server* server = (Server*)cl->screen->screenData;

    cl->clientData =
        new ClientData(server->video.getFrameRate(), &server->input);
    cl->clientGoneHook = clientGone;
    if (!server->numClients++)
    {
        server->pendingResize = false;
        server->frameCounter = 0;
        server->video.start();
    }

    return RFB_CLIENT_ACCEPT;
}

void Server::doResize()
{
    rfbClientIteratorPtr it;
    rfbClientPtr cl;

    framebuffer.resize(
        video.getHeight() * video.getWidth() * Video::bytesPerPixel, 0);

    rfbNewFramebuffer(server, framebuffer.data(), video.getWidth(),
                      video.getHeight(), Video::bitsPerSample,
                      Video::samplesPerPixel, Video::bytesPerPixel);
    rfbMarkRectAsModified(server, 0, 0, video.getWidth(), video.getHeight());

    it = rfbGetClientIterator(server);

    while ((cl = rfbClientIteratorNext(it)))
    {
        ClientData* cd = (ClientData*)cl->clientData;

        if (!cd)
        {
            continue;
        }

        // delay video updates to give the client time to resize
        cd->skipFrame = video.getFrameRate();
    }

    rfbReleaseClientIterator(it);
}

} // namespace ikvm
