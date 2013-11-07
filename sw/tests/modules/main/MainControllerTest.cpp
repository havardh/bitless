#include "CppUTest/CommandLineTestRunner.h"
#include "MainController.h"

TEST_GROUP(MainController) {
    void setup() {}
    void teardown() {}
};

TEST(MainController, shouldHaveInitFunction) {
    MainController_init();
}

TEST(MainController, shouldHaveRunFunction) {
    MainController_run();
}
