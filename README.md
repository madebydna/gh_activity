# README

## GitHub Activity Feed
This simple Rails web application uses the [GitHub Events API](https://developer.github.com/v3/activity/events) to display a GitHub user's recent activity.

### Basic Functionality
A text field on the home page prompts for a GitHub username. Once the form is submitted, an API request to GitHub is initiated and attempts to retrieve the 30 most recent public activities for the given user.

Activities are displayed with their activity type, a date created indicator, the associated repository, and customized details for select activities. Details are displayed for the following activity types:
- `Create`
- `Issue`
- `IssueComment`
- `PullRequest`
- `PullRequestReviewComment`
- `Push`

The code is extensible and can easily support more activity types as needed.

### Error Handling
The following errors are handled gracefully:
- GitHub user not found
- Any other non-successful response code from GitHub
- A list of common HTTP errors, such as "Bad Response", or "Connection Reset"

### Rate Limit and ETag Support
The GitHub API sets a rate limit of 60 requests per hour for unauthorized requests. However, if the ETag value is submitted as part of the request header, then multiple requests to retrieve the same user's recent activity return a `304 Not Modified` response and don't count against the rate limit.

The built-in Rails cache with a Redis backend is used to keep track of the remaining number of allowed requests. If the maximum number is reached, further API requests are prevented until the cached value of `remaining_requests` expires. Cache expiration is determined by the `X-RateLimit-Reset` header supplied by the GitHub API.

The cache is also used to store a user's ETag value and her activity data for subsequent requests. This allows for speedy responses in the case of a `304`, as the data is returned from the cache rather than the API.

### Tests
Testing is done with RSpec to verify the functionality of the `ActivityFetcher` class which is responsible for API interactions. The `webmock` gem is used to stub out API responses in order to avoid hitting API endpoints in tests.

The value object `Activity::Base` and its subclasses represent the activity structure returned by the GitHub API and are also tested thoroughly with RSpec.

### Deployment
Continuous Integration is achieved with CicleCI (see `.circleci/config.yml`). The GitHub repository is hooked up to CircleCI to build the project and run the test suite on all branches of the repo and on all pull requests. In addition, a successful build of the master branch will also trigger a deploy to Heroku.

The site is accessible on Heroku via [https://whispering-badlands-39266.herokuapp.com/](https://whispering-badlands-39266.herokuapp.com/)
