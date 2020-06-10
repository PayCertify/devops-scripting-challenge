import git
import os
import ci
import yaml

TEST_DICT = [{'build':{'cmd': 'mvn clean install'}}]

def test_file_parse():
    if os.path.isdir(os.getcwd()+'/app'):
        os.system('rm -rf {}/app'.format(os.getcwd()))
    repo = git.Repo.clone_from('https://github.com/PayCertify/devops-scripting-helloworld', 'app')
    os.chdir('app')

    with open("pipeline.yml") as f:
        y = yaml.safe_load(f)
        (output1, output2) = ci.parse_yaml_file(y, repo)
        assert isinstance(output1, (list))
        assert isinstance(output2, (list))

def test_task_names():

    output = ci.get_task_names(TEST_DICT)
    assert isinstance(output, (list))
    assert output[0] == "build"





if __name__ == '__main__':
    test_file_parse()
    test_task_names()


