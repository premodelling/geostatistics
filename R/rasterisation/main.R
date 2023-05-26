# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 26/05/2023

pathstr <- file.path(getwd(), 'R', 'rasterisation')

# create book
bookdown::render_book(input = pathstr, output_file = 'input.pdf', output_dir = pathstr,
                      output_yaml = file.path(pathstr, '_output.yml'))

# clean-up
string <- file.path(pathstr, 'index.log')
if (file.exists(string)) {
  base::unlink(x = string)
}
