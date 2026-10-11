# Import libraries
import re

# Import modules
from igor import (
	IGOR_ACTION_RUN,
	IGOR_RUNTIME_VM,
	IGOR_RUNTIME_YYC,
	igor_build_command,
	igor_prepare_directories,
	igor_run,
	igor_run_captured,
)
from project import (
	project_find_file,
	project_get_root,
	project_get_sandbox,
	project_read_ide_version,
)
from runtime import (
	runtime_find,
	runtime_find_prefabs,
	runtime_find_user_directory,
	runtime_warn_if_unverified,
)

# Constants
RUN_WORK_DIR_NAME = "igor"
RUN_ENV_TEST = {"RESNIP_MODE": "test"}
RUN_ENV_BENCH = {"RESNIP_MODE": "bench"}
RUN_RESULT_PATTERN = re.compile(r"\[RESULT\] (\d+) passed, (\d+) failed")


# Functions
def run_prepare(args):
	runtime_warn_if_unverified()
	root = project_get_root()
	project_file = project_find_file(root)
	runtime = runtime_find(args, project_read_ide_version(project_file))
	user_directory = runtime_find_user_directory(args, runtime)
	prefabs_directory = runtime_find_prefabs(args, runtime)

	work_directory = project_get_sandbox(root) / RUN_WORK_DIR_NAME
	igor_prepare_directories(work_directory)
	compiler = IGOR_RUNTIME_YYC if args.yyc else IGOR_RUNTIME_VM
	command = igor_build_command(
		runtime,
		user_directory,
		prefabs_directory,
		project_file,
		work_directory,
		IGOR_ACTION_RUN,
		compiler,
	)
	print(
		f"[INFO] Starting Igor with runtime {runtime.version} and {compiler}, close the game window to finish"
	)
	return root, command


def run_game(args):
	root, command = run_prepare(args)
	return igor_run(command, root)


def run_bench(args):
	root, command = run_prepare(args)
	return igor_run(command, root, RUN_ENV_BENCH)


def run_test(args):
	root, command = run_prepare(args)
	code, lines = igor_run_captured(command, root, RUN_ENV_TEST)
	results = [RUN_RESULT_PATTERN.search(line) for line in lines]
	results = [match for match in results if match]
	if not results:
		print(
			"[ERROR] The game printed no result line. Check that the test object ran and that Igor shows the game output."
		)
		return 1
	failed = int(results[-1].group(2))
	if failed or code:
		print(f"[ERROR] {failed} tests failed, game exit code {code}")
		return 1
	print(f"[INFO] {results[-1].group(1)} tests passed")
	return 0
