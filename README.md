vimenode
===
---
A JavaScript wrapper for the Vimeo APIs. VIH-mee-node, like VIH-mee-oh. Get it?

### INSTALL

Install globally:

    npm install -g vimenode

Or add to your `package.json`:

    {
      "dependencies": {
        "vimenode": "*"
      }
    }

And install with `npm install`.

### USAGE

#### Simple

    var vimendoe = require('vimenode').simple;

Each request type supported by the [Simple API](https://developer.vimeo.com/apis/simple) has its own corresponding function in vimenode.

##### User Requests

    vimenode.user(username, method, page, callback)

##### Video Requests

    vimenode.video(video_id, callback)

##### Activity Requests

    vimenode.activity(method, username, page, callback)

##### Group Requests

    vimenode.group(method, groupname, page, callback)

##### Channel Requests

    vimenode.channel(method, channelname, page, callback)

##### Album Requests

    vimenode.album(method, albumn_id, page, callback)

#### Advanced

@TODO: Everything. Coming soon-ish.

### EXAMPLE

##### Fetching a list of a user's video ids

    var v = require('vimenode').simple;

    var video_ids = [];
    v.user('all_videos', 'username', function(videos) {
      videos.forEach(function(video) {
        video_ids.push(video.id);
      });

      console.log(video_ids);
    });

##### Get more info about users that someone has followed recently

    var v = require('vimenode').simple;

    v.activity('user_did', 'username', function(activities) {
      activities.forEach(function(activity) {
        if (activity.type === 'follow_user') {
          return v.user('info', activity.subject_id, function(user_info) {
            console.log(user_info);
          });
        }
      });
    });
