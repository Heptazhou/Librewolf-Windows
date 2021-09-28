# website structure

The [LibreWolf website](https://librewolf-community.gitlab.io/) is built using the Gitlab machinery. The website is generated from .md (markdown) files (see [markdown guide](https://www.markdownguide.org/)). The bulk of a page on the website is generated from .md into .html by the [hugo static site generator](https://gohugo.io/). Of course, the website contains grahics/css/javascript. 

So we have our website divided into two parts:
* Repository: [LibreWolf-Community.gitlab.io](https://gitlab.com/librewolf-community/librewolf-community.gitlab.io) - The repository that contains the instructions for Hugo/Github how to generate and host the website. Low-level repository.
* Repository: [Docs](https://gitlab.com/librewolf-community/docs) - The actual documentation we're going to work with, on [this url](https://librewolf-community.gitlab.io/docs) in the website. High-level repository.

## Low-level repository:

Within the low-level repository, there are two interesting subdirectories. First, the [static](https://gitlab.com/librewolf-community/librewolf-community.gitlab.io/-/tree/master/static) folder contains all the images, javascript, fonts and css for the website.

Second, the [content](https://gitlab.com/librewolf-community/librewolf-community.gitlab.io/-/tree/master/content) folder. It contains an **install.md** with _installation instructions for the user_ wanting to try, install, or upgrade LibreWolf. Second interesting item: _docs @ 22e7df52_ which is a link to the actual 'Docs' repository. And this is how the low-level part of the website 'knows how to find' the High-level part.

As you can tell, I would be much more happy if that install.md would actually be in the Docs repository, but ok. (Logically, install.md is where you end up clicking 'install' on the main page, and 'docs' is where you end up clicking the 'documentation' button/link.) Let's go to the high-level repository.

## High-level repository:

The main repository folder has all the .md files right there, and all of them are interesting, except for the _readme.md_ and _licence.md_. 

It contains only one subfolder (settings) with one file in it: _index.md. This looks like an inconsistency, but the idea is probably to have quite a lot of explanation and documentation and pages on the settings in LibreWolf (which form the core of LibreWolf). You can see this substructure reflected in the site navigation on top (this is all done by _Hugo_).

How does the mapping from .md files to .html pages work? Well, every .md page maps directly to an .html url on the website. So if you create a new file, it will get picked up automatically by the Hugo site generator, and a navigation link will get created. If you want to do that, the first line must be of the form:

    ---
    title: My page
    ---

    # My page

    Hi there, this is my new page. Lorem ipsum etc.

That's basically all about the website structure. All the pages count, and their title: on the first section tells you what their 'navigation' title is. If you delete such an .md file, it disappears from the site.

### My other notes/topics

* I feel that the **install.md** file is critical. This is what people who do not read click on to 'just give me LibreWolf'. This is especially true for Windows/Apple users. The Linux crowd is different and much more hardcore. In a way we want to make things easy clickable for the Windows/Apple users, and clear and consise for the Linux users.
* Second, the **docs / _index.md** file is critical. This is where people land when they click on 'Documentation'. I'm not sure what they would want to read first, but it should point the way to the documentation in general and how it is structured.
