# Merge Request (MR) how-to

This page is ment to document how to edit something, using an MR, on the [LibreWolf website](https://librewolf-community.gitlab.io/). I would perhaps recommend to read the _website_structure.md_ documentation first to get an overview of the website.

I'm a big proponent of editing the .md files right in the Gitlab website, no need to clone the files locally or any of that complicated stuff, it can all be done from the website, using a comfortable markdown editor which has a Write/Preview pane, bold and italics buttons, link buttons, most of the stuff we need. Also, it will make the MR merge process much easier and non-technical. As a bonus, because it's on the website one can edit pages from the web browser on mobile. The only downside to this is that we do not get _GnuPG cryptographically signed_ merge requests, but for .md files I guess that's really not a problem, the content is one-to-one with what people see on the website.

Ok, so that's what we're going to do, edit a page via the website. I will use the **docs / settings / _index.md** file as our running example.

## Edit process in practical steps

* We locate the .md file we want to edit in the source repository, in our example, we navigate to [this page](https://gitlab.com/librewolf-community/docs/-/blob/master/settings/_index.md).
* We see a preview of the .md file, formatted roughly the way it looks on the site. We click the blue 'Edit' button.
* It says: > You're not allowed to edit files in this project directly. Please fork this project, make your changes there, and submit a merge request. 
* Click 'Fork' right after that error message. 
* It will fork, and then it will take you to the online editor.
* This editor is ideal, with a 'Write' tab that allows us to type in the markup text, and a 'Preview' tab that shows us how the page is going to look like when it appears on the website.
* We do our editing, \<type-type-type-type> until we're done.
* When done, we scroll down to the bottom of the page, and click the green 'Commit changes' button.
* We now end up in the 'Submit Merge Request' page, where we explain in short form what the change is about. No need to be too strict about this.
* We press the green 'Submit merge request' button.
* We end up in the Merge Request page for our MR. You can always find all open MR's on the Github navigation to the left.
* **Now it's out of our hands.** We wait until an admin/maintainer approves of our change, submit the change to the repository, and let the new version  be generated and displayed on the website.
