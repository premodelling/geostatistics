# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 26/05/2023

root <- file.path(getwd(), 'R', 'rasterisation')

# create book
bookdown::render_book(input = root, output_file = 'input.pdf', output_dir = root,
                      output_yaml = file.path(root, '_output.yml'))

# clean-up
string <- file.path(root, 'input.log')
if (file.exists(string)) {
  base::unlink(x = string)
}
