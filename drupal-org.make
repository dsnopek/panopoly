api = 2
core = 7.x

; The Panopoly Foundation

projects[panopoly_core][version] = 1.x-dev
projects[panopoly_core][subdir] = panopoly
projects[panopoly_core][download][type] = git
projects[panopoly_core][download][revision] = 99cb79e
projects[panopoly_core][download][branch] = 7.x-1.x

projects[panopoly_images][version] = 1.x-dev
projects[panopoly_images][subdir] = panopoly
projects[panopoly_images][download][type] = git
projects[panopoly_images][download][revision] = e07c68a
projects[panopoly_images][download][branch] = 7.x-1.x

projects[panopoly_theme][version] = 1.x-dev
projects[panopoly_theme][subdir] = panopoly
projects[panopoly_theme][download][type] = git
projects[panopoly_theme][download][revision] = 2931b15
projects[panopoly_theme][download][branch] = 7.x-1.x

projects[panopoly_magic][version] = 1.x-dev
projects[panopoly_magic][subdir] = panopoly
projects[panopoly_magic][download][type] = git
projects[panopoly_magic][download][revision] = 5c77f38
projects[panopoly_magic][download][branch] = 7.x-1.x

projects[panopoly_widgets][version] = 1.x-dev
projects[panopoly_widgets][subdir] = panopoly
projects[panopoly_widgets][download][type] = git
projects[panopoly_widgets][download][revision] = 88f1146
projects[panopoly_widgets][download][branch] = 7.x-1.x

projects[panopoly_admin][version] = 1.x-dev
projects[panopoly_admin][subdir] = panopoly
projects[panopoly_admin][download][type] = git
projects[panopoly_admin][download][revision] = 488ead6
projects[panopoly_admin][download][branch] = 7.x-1.x

projects[panopoly_users][version] = 1.x-dev
projects[panopoly_users][subdir] = panopoly
projects[panopoly_users][download][type] = git
projects[panopoly_users][download][revision] = 621f63e
projects[panopoly_users][download][branch] = 7.x-1.x

; The Panopoly Toolset

projects[panopoly_pages][version] = 1.x-dev
projects[panopoly_pages][subdir] = panopoly
projects[panopoly_pages][download][type] = git
projects[panopoly_pages][download][revision] = a8fdb07
projects[panopoly_pages][download][branch] = 7.x-1.x

projects[panopoly_wysiwyg][version] = 1.x-dev
projects[panopoly_wysiwyg][subdir] = panopoly
projects[panopoly_wysiwyg][download][type] = git
projects[panopoly_wysiwyg][download][revision] = 19209fa
projects[panopoly_wysiwyg][download][branch] = 7.x-1.x

projects[panopoly_search][version] = 1.x-dev
projects[panopoly_search][subdir] = panopoly
projects[panopoly_search][download][type] = git
projects[panopoly_search][download][revision] = d101070
projects[panopoly_search][download][branch] = 7.x-1.x

; For running the automated tests.

projects[panopoly_test][version] = 1.x-dev
projects[panopoly_test][subdir] = panopoly
projects[panopoly_test][type] = module
projects[panopoly_test][download][type] = git
projects[panopoly_test][download][revision] = 24aa950
projects[panopoly_test][download][branch] = 7.x-1.x

# Adding patches from issue:
projects[panopoly_test][patch][] = https://www.drupal.org/files/issues/panopoly_test-make-removed-view-modes-setting-2170695-14.patch
projects[panopoly_magic][patch][] = https://www.drupal.org/files/issues/panopoly_magic-make-removed-view-modes-setting-2170695-10.patch
