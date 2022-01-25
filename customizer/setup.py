import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="openbikesensor-case-customizer",
    version="0.0.1",
    author="gluap",
    author_email="github@pgoergen.de",
    description="OpenBikesSensor 3D Printable Case customizer",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/openbikesensor/OpenBikeSensor3dPrintableCase",
    project_urls={
        "Bug Tracker": "https://github.com/openbikesensor/OpenBikeSensor3dPrintableCase/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),
    python_requires=">=3.6",
    install_requires=[
        "fastapi",
        "python-multipart",
        "jinja2",
        "pkgutil",
        "pyyaml",
        "pydantic",
        "sse_starlette",
        "asyncioinotify"
    ]
)