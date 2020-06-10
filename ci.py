import os
import yaml
import sys
import git
import argparse

def get_task_names(tasks):
    '''
    Helper function to pull just the key names for all possible tasks
    into a list and is returned
    Returns a list
    '''
    arr = []
    for i in range(len(tasks)):
        for x, y in tasks[i].items():
            arr.append(x)

    return arr


def parse_yaml_file(yaml_file, repo):
    '''
    Parses yaml file.  Checks out the branch that is declared.  Parses pipelines and tasks into seperate dictionaries
    Returns two dictionaries
    '''
    
    # Checkouts out branch from pipeline file
    repo.git.checkout(yaml_file.get('branch'))
    pipelines = yaml_file.get('pipelines')
    tasks = yaml_file.get('tasks')

    return pipelines, tasks


def parse_cli_arguments():
    '''
    Uses argeparse to take in cli arguments for task to run and repo to clone
    Returns two strings
    '''

    parser = argparse.ArgumentParser(description="Build your own ci")
    parser.add_argument('task')
    parser.add_argument('repo')
    args = parser.parse_args()
    return args.task, args.repo



def main():
    if os.path.isdir(os.getcwd()+'/app'):
        os.system('rm -rf {}/app'.format(os.getcwd()))
    (pipelineToRun, url) = parse_cli_arguments()
    repo = git.Repo.clone_from(url, 'app')


    # Changing to repo and checking if pipeline file exists
    os.chdir('app')
    if os.path.isfile('./pipeline.yml') == False:
        raise OSError("Pipeline.yml file not found")

    # Opens pipeline file
    with open ('pipeline.yml') as f:

        # Loads yaml file into ciCommands dictionary
        ciCommands = yaml.safe_load(f)
        # Parses yaml file into dicts of pipelines and tasks
        (pipelines, full_tasks) = parse_yaml_file(ciCommands, repo)
        # Strips tasks to just their name for matching
        task_names = get_task_names(full_tasks)
        # Iterates through all pipelines
        for i in range(len(pipelines)):
            for key, value in pipelines[i].items():
                # If the pipeline passed to the script is valid, it will run all the tasks,
                # Otherwise a value error is raised.
                if pipelineToRun == key:
                    for task in value:
                        os.system(full_tasks[task_names.index(task)][task]['cmd'])
    f.close()
if __name__ == '__main__':
    main()



