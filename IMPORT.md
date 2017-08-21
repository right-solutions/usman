# Importing the data

Basic Usage

## Importing Master Data

Use the following scripts to import master data - Roles

role data is a csv file.

pass verbose=false to avoid printing more details while running these commands.

### Importing roles

This will import roles parsing the csv file 'roles.csv' located in db/master_data
```rails usman:import:master_data:roles```


## Importing Dummy Data

Use the following scripts to import dummy data - User, Features, Roles & Permissions

All dummy data should be in a csv file and should be located in db/import_data/dummy.

pass verbose=false to avoid printing more details while running these commands.

### Importing users

```rails usman:import:data:dummy:users```

This will import users parsing the csv file 'users.csv' located in db/data/dummy

### Importing features

```rails import:data:dummy:features```

This will import features parsing the csv file 'features.csv' located in db/data/dummy

### Importing roles

```rails usman:import:data:dummy:roles```

This will import roles parsing the csv file 'roles.csv' located in db/data/dummy

### Importing permissions

```rails usman:import:data:dummy:permissions```

This will import permissions parsing the csv file 'permissions.csv' located in db/data/dummy


### Importing all together in one line

```rails usman:import:data:dummy:users usman:import:data:dummy:features usman:import:data:dummy:roles usman:import:data:dummy:permissions```

This can also be achieved in a single task

```rails usman:import:data:dummy:all```


## Importing Real Data for Production

All real data should be in a csv file and should be located in db/data.

```rails usman:import:data:users```
```rails usman:import:data:features```
```rails usman:import:data:roles```
```rails usman:import:data:permissions```

