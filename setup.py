from setuptools import find_packages, setup

with open("requirements.txt") as f:
    requirements = f.read().splitlines()

setup(
    name="etl",
    version="0.0.1",
    include_package_data=True,
    python_requires=">=3.11",
    packages=find_packages(),
    setup_requires=["setuptools-git-versioning"],
    install_requires=requirements,
    author="Frederic Marechal",
    author_email="freddy.marechal@gmail.com",
    description="This is the Extract Transform Load Module",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    classifiers=[
        "Programming Language :: Python :: 3.11",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    version_config={
        "dirty_template": "{tag}",
    },
)
