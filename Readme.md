# Teamwork project

I've built a Sirikit extension, which allows you to add multiple tasks and mark tasks as done by name

## Example usage:

Tell Siri:

- Add apples and oranges in TeamworkProject
- Mark apples completed in TeamworkProject

The project list is hardcoded to https://yat.teamwork.com/index.cfm#/tasklists/1413042 and all the tasks are added to this list only, but you can easily extend the app to be able to specify tasklists or even add new ones with Siri

The app uses fuzzy matching (via 3rd party library) to automatically correct task names and match them against tasks in a task list

I've added some integration tests which work against the live API.

## Adding multiple tasks

![Add tasks](/images/teamwork_addtasks.png)

## Mark a task as completed (note the misspelling)

![Add tasks](/images/teamwork_completed.png)