# Privacy

This web site uses Google Analytics (GA) as a tool to analyze content popularity.

GA is the easiest solution that came to my mind: it has a [good plugin](https://www.npmjs.com/package/gitbook-plugin-ga) for gitbook and it fits very well with static sites.
However, I understand that it is not ideal in terms of privacy.

Since our goal is not to spy on users, many GA features were disabled. In particular:

* GA cookies are disabled and no other mechanism to track users is implemented;
* User IPs are anonymized;
* SSL is forced when data are sent to GA;

Moreover, users can clone the gh project, disable ga (content/book.json) and read the gitbook locally.

However, if you think that users privacy is not protected by these restrictions, please write me.
