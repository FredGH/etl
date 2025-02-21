
# ETL

## Description
Extract Transform Load data from a staging area to a consumer area.

## Structure of the project
** 1) Staging
** 2) Transformation

## Testing

## Getting Started

### Profiles.yml
A profiles.yml file needs to be created and populated accordingly.

### Installing
* Git clone the project
    * git clone https://github.com/FredGH/etl.git
* Create the Python Env
    * rm -rf venv/
    * python3.11 -m venv venv
    * source ./venv/bin/activate
* Install Requirements:
    * python3.11 -m pip install --upgrade pip
    * [optional] mkdir $HOME/.dbt
    * [optinal] cp profiles.yml $HOME/.dbt/
* Build Package:    
    * pip3.11 install -U pip setuptools
    * python3.11 setup.py sdist bdist_wheel
    * pip3.11 install -e .
    * [optional] pip install -Iv urllib3==1.26.15
* Init dbt
    *  [optional]  rm -rf dbt_packages
    *  python3 ./scripts/dbt_init.py     
    * dbt build [model_name]
* Run fal   
    * fal run ./fal_scripts/test.py
    


### Unit Tests Run
* Run unit tests
    * run in /dataproviders 
        * coverage run -m unittest discover
        * coverage report -m (or coverage hml)

### Code Pretiffy
* Code cleanup & Standardisation
    * ruff check . &isort . &black .

### Executing program
* python3 ./scripts/dbt_run.py

## Help
* Please contact the author

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
