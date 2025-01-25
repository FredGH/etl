import subprocess

def run_command(commands):
    try:
        for command in commands:
            # Run the command
            result = subprocess.run(command, check=True, text=True, capture_output=True)
            
            # Print the output
            print("*** Successful run of {0}:\n {1}".format(command, result.stdout))
        
    except subprocess.CalledProcessError as e:
        # Print the error if the command fails
        print("*** Error in run_command script:\n {0} - msg:{1}".format(e, e.stderr))
