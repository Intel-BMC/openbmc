#include "ikvm_args.hpp"
#include "ikvm_manager.hpp"

int main(int argc, char* argv[])
{
    ikvm::Args args(argc, argv);
    ikvm::Manager manager(args);

    manager.run();

    return 0;
}
