# Time recording

## Installation
For the installation, ruby version **3.2.0** and rails version **7.0.4** are required.

You can then set up the project using the following commands

```bash
$ npm install 
$ bundle install
$ rails s
```

## Database

For creation and migration, use the following commands:
```bash
$ rails db:create
$ rails db:migrate
```

For testing purposes, test data can be written to the database with the following command
```bash
$ rails db:seed
```



## Tests
You can start the test with
```bash
$ rails test
```

### System tests
```bash
$ rails test:system
```
In the system test, Turbo does not work due to the yarn installation. Therefore, only a few system tests were written and controller tests were used instead. To run the application with turbo again after the system tests, **remove the yarn.lock file** and run **npm install** again.




