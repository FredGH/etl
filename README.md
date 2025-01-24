# ETL

## Description

Extract Transform Load data from a landing area to a consumer area

## Getting Started

### Dependencies

* N/A

### Installing
* Git clone the project
    * git clone https://github.com/FredGH/etl.git
* Create the Python Env
    * rm -rf venv/
    * In Visual Studio Vode -> Ctrl+Shift+P -> Select Interpreter ->  Python 3.11.x
    * python3.11 -m venv venv
    * source ./venv/bin/activate
    * In Visual Studio Vode -> Ctrl+Shift+P -> Select Interpreter ->  (venv) Python 3.11.x
    * [optional] check Python3 version -> python3 -> should show Python 3.11.x

* Install Requirements:
    * python3.11 -m pip install --upgrade pip
    * mkdir $HOME/.dbt
* Build Package:    
    * pip3.11 install -U pip setuptools
    * python3.11 setup.py sdist bdist_wheel
    * pip3.11 install -e .

    * create the dbt_pject file + profiles.yml and then try the dbt_script again...
    then follow that
    https://github.com/fal-ai/fal_dbt_examples
    then follow that:
    https://github.com/jmbrooks/dbt-project-template

    * [optional] pip install -Iv urllib3==1.26.15
* Tag New Release & Push:
    * git tag 0.0.x -m "Release details"
    * git push origin 0.0.x
    * git push
* Install Package:
    *  Go to Settings > Developer Settings > Personal access tokens (classic) > Generate new token with note e.g. "Upload package"
    *  Ensure you check the write:packages scope to grant the necessary permissions.
    * Get the generated token, e.g. "12345"
    * Get your Github user name, e.g. "my_user_name"
    * Install the private package using the following:
        * Template:
            * pip3.11 install git+https://github.com/{{ username }}/{{ package name }}.git@{{ tag/version }}
            * [Optional] pip3.11 install git+https://{{ your access token }}@github.com/{{ username }}/{{ repository name}}.git@{{ tag/version }}#egg={{ package name }}
        * Example:
            * pip3.11 install git+https://github.com/{{ username }}/data_providers.git@0.0.x
            * [Optional] pip3.11 install git+https://12345@github.com/{{ username }}/data_providers.git@0.0.x#egg=data_providers    
    * [Optional] Deleting tags:
        * List tags: git tag -l
        * Delete origin: git push origin :refs/tags/{{tagname}} (e.g. 0.01)
        * Delete locally: git tag --delete {{tagname}} (e.g. 0.01)

* Code cleanup & Standardisation
    * ruff check . &isort . &black .

* Run unit tests
    * run in /dataproviders 
        * coverage run -m unittest discover
        * coverage report -m (or coverage hml)

### Executing program

* N/A

## Help

* N/A

## Authors

Contributors names and contact info
freddy.marechal@gmail.com

## Version History

* 0.0.1
    * TBC

## License

* There is no license.

## Acknowledgments

Inspiration, code snippets, etc.
* [Create and Release Private Python Package On Github](https://dev.to/abdellahhallou/create-and-release-a-private-python-package-on-github-2oae)
