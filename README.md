# project-link2
this my project-link


### Finds all relevant problems

* No link-checker can _guarantee_ correct results: the web is too flaky 
  for that. But at least the tool should correctly parse the HTML (not just
  try to guess what's a URL and what isn't) and 
  the CSS (for `url(...)` links).
  
  * PENDING: srcset support

#### Leaves out irrelevant problems

* `linkcheck` doesn't attempt to render JavaScript. It would make
  it at least an order of magnitude slower and way more complex. (For example,
  what links and buttons should the tool attempt to click, and how many
  times? Should we only click visible links? How exactly do we detect broken
  links?) Validating SPAs is a very different problem than checking static 
  links, and should be approached by dedicated tools.


  * `linkcheck` only supports `http:` and `https:`. It won't try to check
  FTP or telnet or nntp links.
  
  * Note: `linkcheck` will currently completely ignore unsupported schemes
    like `ftp:` or `mailto:` or `data:`. This may change in the future to
    at least show info-level warning.
  
* `linkcheck` doesn't validate file system directories. Servers often behave
  very differently than file systems, so validating links on the file system
  often leads to both false positives and false negatives. Links should be 
  checked in their natural habitat, and as close to the production environment
  as possible. You can (and should) run `linkcheck` on your localhost server,
  of course.
  
