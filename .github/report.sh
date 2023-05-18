#!/bin/sh

cargo cov -- report
  $(
    for file in
      $(
        RUSTFLAGS="-C instrument-coverage"
        RUSTDOCFLAGS="-C instrument-coverage -Z unstable-options --persist-doctests target/debug/doctestbins"
          cargo test --no-run --message-format=json
            | jq -r "select(.profile.test == true) | .filenames[]"
            | grep -v dSYM -
       )
       target/debug/doctestbins/*/rust_out;
    do
      [[ -x $file ]] && printf "%s %s " -object $file;
    done
  )
 --instr-profile=merged.profdata --summary-only
    
