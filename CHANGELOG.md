# CHANGELOG

##### Changelog v2.0.2 27/06/2017:

- New attribute `default["tomcat"]["restart"]` and variable `restart` added in `run_proc.rb` recipe to manage Tomcat7 service.

- Resource `file "C:\chef\#{$jar_name}.jar"` was replaced by `ruby_block 'Delete .jar Files'` resource.

##### Changelog v2.0.1 22/06/2017:

- Variable `message_jar` added in `run_proc.rb` recipe to know the result of running jar if chef-client fails.

##### Changelog v2.0.0 04/04/2017:

- Improve code of recipes and helpers according to Ruby Style Guide.

- Some methods changed their name.

- New global variables `$node_name` and `$jar_source` added in `default.rb` recipe.

- New `fetch` method added to module `Tools`. This method is used in `default.rb` recipe.

- Attributes `default["jar-merc"]["url"]` and `default["jar-merc"]["name"]` were replaced by `default["jar-merc-bog"]["url"]`, `default["jar-merc-bog"]["name"]`, `default["jar-merc-buc"]["url"]` and `default["jar-merc-buc"]["name"]`.

- New resource `log "jar downloaded from #{$jar_source}"` added in `run_proc.rb` recipe.

##### Changelog v1.0.2 20/01/2017:

- Attributes `default["jar"]["url"]` and `default["jar"]["name"]` was replaced by `default["jar-bbi"]["url"]`, `default["jar-bbi"]["name"]`, `default["jar-merc"]["url"]` and `default["jar-merc"]["name"]`.

##### Changelog v1.0.1 06/01/2017:

- The function `getFolder` of `Java` module changed to `getExe` and returns the path of `java.exe` executable.

- Now the confirmation email doesn't include the log.

##### Changelog v1.0.0 05/01/2017:

- Now the cookbook is modular. Separate the preparation and run process.

- New `prepare.rb` and `run_proc.rb` recipes.

##### Changelog v0.3.0 05/01/2017:

- Now the execution of jar generates a log file with the execution's response.

##### Changelog v0.2.4 28/12/2016:

- Now method `getFolder` of `Java` module return `jre7` path.

##### Changelog v0.2.3 09/12/2016:

- Added varible `prefix` to modify the command that executes the jar if node has Windows 10 OS.

##### Changelog v0.2.2 06/12/2016:

- New module `Java` contains `getFolder` function.

##### Changelog v0.2.1 21/11/2016:

- Attribute `default["jar"]["name"]` was added to manage the name of jar.

- Resources, where name of jar was static, change your syntax.

##### Changelog v0.2.0 03/11/2016:

- Resources `windows_service 'Tomcat7'` and `ruby_block 'Wait Tomcat'` were added to manage tomcat service.

- Method `waitStart` of `Tomcat` module send a email if node need help to restart tomcat service.
