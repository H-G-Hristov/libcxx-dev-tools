#!/bin/sh

################################################################################
# Delete `.DS_Store`
################################################################################

main()
(
  find . -name ".DS_Store" -type f -delete
)

################################################################################

main "$@"
