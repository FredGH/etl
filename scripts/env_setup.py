import utils

commands = []
commands.append(["rm",  "-rf", "venv/" ])
commands.append(["python3.11", "-m", "venv", "venv" ])
commands.append(["source ", " ./venv/bin/activate"])
utils.run_command(commands)



