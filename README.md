
                                                      Medium Interface
Implementation
  min.asm - x86 binary
  min.c - unix c compiler
  min.swift - apple swift
  min.z80 - z80 binary
  min.i - intermediate

Interactive shell
  .key - invoke
  . - return
  ; - next
  ? - if
  @ - loop
  // - comment

Sample
  crlf = 0D, 0A // crlf = 0D 0A is the same
  msg = 'sh.i - shell interactive (c) 2017', crlf
  .puts msg
  input:      // loop label
  cmd = .gets
  cmd == 'ver' ? .puts crlf, msg, ' version', .ver, crlf; // continue code block by ;
    @ input // jmp
  cmd == '.' ? .puts 'not implemented\n'; @ input // \n is acceptable
  ver:  . 0 // return 0
