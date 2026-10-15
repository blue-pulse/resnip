// Test settings
#macro __RESNIP_TEST_TOLERANCE 0.0001
#macro __RESNIP_TEST_DESCRIBE_LENGTH 120
#macro __RESNIP_TEST_GAMESPEED 15
#macro __RESNIP_TEST_EXIT_PASSED 0
#macro __RESNIP_TEST_EXIT_FAILED 1

// Random numbers for generated cases
#macro __RESNIP_TEST_RANDOM_MASK 0x7fffffff
#macro __RESNIP_TEST_RANDOM_MULTIPLIER 1103515245
#macro __RESNIP_TEST_RANDOM_INCREMENT 12345
#macro __RESNIP_TEST_RANDOM_SHIFT 8

// Size of the generated cases
#macro __RESNIP_TEST_CASES 200
#macro __RESNIP_TEST_STEPS 60

// Run modes, chosen with the environment variable
#macro __RESNIP_RUN_VARIABLE "RESNIP_MODE"
#macro __RESNIP_RUN_TEST "test"
#macro __RESNIP_RUN_BENCH "bench"
