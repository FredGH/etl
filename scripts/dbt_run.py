import utils

commands = []
commands.append(["dbt", "build"])
commands.append(["fal", "run"])
utils.run_command(commands)



