import utils

commands = []
commands.append(["dbt", "clean"])
commands.append(["dbt", "deps"])
commands.append(["dbt", "seed"])
utils.run_command(commands)



