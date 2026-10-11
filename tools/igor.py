# Import libraries
import os
import platform
import subprocess

# Constants
IGOR_PLATFORM_NAMES = {"Windows": "Windows", "Darwin": "Mac", "Linux": "Linux"}
IGOR_PROCESSOR_COUNT = "1"
IGOR_ACTION_RUN = "Run"
IGOR_RUNTIME_VM = "VM"
IGOR_RUNTIME_YYC = "YYC"


# Functions
def igor_prepare_directories(work_directory):
	for name in ("cache", "temp"):
		(work_directory / name).mkdir(parents=True, exist_ok=True)


def igor_build_command(
	runtime,
	user_directory,
	prefabs_directory,
	project_file,
	work_directory,
	action,
	compiler=IGOR_RUNTIME_VM,
):
	return [
		str(runtime.igor),
		f"/uf={user_directory}",
		f"/rp={runtime.directory}",
		f"/project={project_file}",
		f"/cache={work_directory / 'cache'}",
		f"/temp={work_directory / 'temp'}",
		f"/runtime={compiler}",
		f"--pf={prefabs_directory}",
		"--",
		IGOR_PLATFORM_NAMES[platform.system()],
		action,
	]


def igor_get_environment(extra=None):
	environment = os.environ.copy()
	# One processor keeps the LTS 2026 runtime stable
	environment["DOTNET_PROCESSOR_COUNT"] = IGOR_PROCESSOR_COUNT
	environment.update(extra or {})
	return environment


def igor_run(command, working_directory, extra_environment=None):
	return subprocess.run(
		command, cwd=working_directory, env=igor_get_environment(extra_environment)
	).returncode


def igor_run_captured(command, working_directory, extra_environment=None):
	process = subprocess.Popen(
		command,
		cwd=working_directory,
		env=igor_get_environment(extra_environment),
		stdout=subprocess.PIPE,
		stderr=subprocess.STDOUT,
		text=True,
		encoding="utf-8",
		errors="replace",
	)
	lines = []
	for line in process.stdout:
		print(line, end="")
		lines.append(line)
	return process.wait(), lines
