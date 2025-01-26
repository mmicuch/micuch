# ENGLISH

> [!IMPORTANT]
>  WORKING DOCKER IS REQUIRED TO RUN THIS PROJECT

## HOW TO RUN

1. Rename your `.env-dist` file to `.env` and change your passwords for your database
2. Import database from `docker\build\mariadb\cms.sql` or create your own
3. Compose up your `docker-compose.yaml` file
4. Open terminal for your 'node' container
5. Run command `npm install` to install all the packages, that the code depends on
6. Run command `node cli/set_password admin "password"` where "password" should be your password for admin login on page
7. Run command `node cli/set_password user "password"` where "password" should be your password for user login on page

## THERE ARE THREE TYPES OF USER

### NOT LOGGED IN
- Can see all the upcoming events
- Can sort the upcoming events by date, name and region
- Can see the detailed page of event
- Can comment on events with any username, except taken ones

### LOGGED USER
- Can see all the upcoming events
- Can sort the upcoming events by date, name and region
- Can see the detailed page of event
- Can comment on events only with his registered username

### ADMIN USER
- Can see all the upcoming events
- Can sort the upcoming events by date, name and region
- Can see the detailed page of event
- Can comment on events only with his registered username
- Can create events
- Can modify events
- Can delete comments
- Can see past events

