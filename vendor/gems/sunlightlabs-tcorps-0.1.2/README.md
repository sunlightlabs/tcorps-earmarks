## Introduction

This is a wrapper for the [TransparencyCorps](http://transparencycorps.org) API.  TransparencyCorps is a microtask directory that integrates with external applications to encourage and reward volunteer activity.

You would use this in your TransparencyCorps campaign application to notify TransparencyCorps when a user has completed a task, and they should receive points for their effort.

## Usage

Your campaign will receive a unique task key for each user when they land on your page from TransparencyCorps.  You should hold this key until the task is completed, perhaps in hidden input fields on your forms, or in whatever session store your application might use.

To complete a task and nothing more:

    TransparencyCorps.complete_task "the_actual_task_key"
    # => #<Net::HTTPOK 200 OK readbody=true>

Your application may want to seamlessly direct users to a new task once they've completed one.  TransparencyCorps can generate a new task for you at the same time as you mark the current task complete, and will return the URL for the app to redirect itself to as the response body.  You can do this with this wrapper by:

    TransparencyCorps.complete_task_and_reassign "the_actual_task_key"
    # => "http://yoursite.com/yourcampaign?task_key=new_task_key&username=testuser&points=500
    
    # or you can get the response body and pull the URL yourself:
    response = TransparencyCorps.complete_task "the_actual_task_key", true
    response.body
    # => "http://yoursite.com/yourcampaign?task_key=new_task_key&username=testuser&points=500
    

By default, the wrapper directs requests to http://transparencycorps.org.  If you want to use a different URL, (for testing in a local or staging environment, for instance), assign it a different one.

    TransparencyCorps.url = "http://localhost:3000"