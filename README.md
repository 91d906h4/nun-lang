<div align="center">
  <img src="https://raw.githubusercontent.com/othneildrew/Best-README-Template/master/images/logo.png" alt="Logo" width="80" height="80">
  <h3 align="center">nun lang</h3>

  <p align="center">
  A turing complete tiny esoteric programming language.
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-nun-lang">About nun lang</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#basic">Basic</a></li>
    <li><a href="#instructors">Instructors</a></li>
    <li><a href="#example">Example</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

## About nun lang

<div align="center">

  ![](https://i.imgur.com/U4iH2iI.png)

  <i>"Hello, World!" program in nun lang.</i>
</div>

nun lang is a turing complete programming language that only use 2 chars (n and u). You can use these two characters to build any machine in theory (if you have enough time).

Basically, u means 0, and n means 1, you can consider this is a machine code level language (only use 0 and 1).

Why we use u and n? Because it's difficult for programmers to read, debug and code.

### Built With

nun lang is built with C (in 200 lines), it makes nun lang to run fast (but you will spend much time to code it).

## Basic

the following is the syntax format of nun lang (64-bits):

| op code | address | remain | data |
| --- | --- | --- | --- |
| 8 | 10 | 6 | 40 |

For example, this line will output a character 'H' (characters are not 'u' or 'n' will be skipped in nun lang):

```
uuuuuuun uuuuuuuuuu uuuuun uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuunuunuuu
00000001 0000000000 000001 0000000000000000000000000000000001001000
-------- ---------- ------ ----------------------------------------
op code   address   remain                  data

// The ASCII code of 'H' is 1001000.
```

## Instructors

nun lang provides 10 operators and3 remain types (for more information please refer to the source code).

## Examples

A program to multiply 1073741825 by 8, and print the result on screen.
```
uuuuunnn uuuuuuuuun uuuuuu uuuuuuuuunuuuuuuuuuuuuuuuuuuuuuuuuuuuuun MOV 1 1073741825
uuuuunnn uuuuuuuunu uuuuuu uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuunuuu MOV 2 8
uuuuunun uuuuuuuuun uuuuuu uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuunu MUL 1 2
uuuuuunu uuuuuuuuun uuuuuu uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu MSGA 1 // 8589934600
```

The compressed version:
```
uuuuunnnuuuuuuuuunuuuuuuuuuuuuuuunuuuuuuuuuuuuuuuuuuuuuuuuuuuuunuuuuunnnuuuuuuuunuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuunuuuuuuuununuuuuuuuuunuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuunuuuuuuunuuuuuuuuuunuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
```

## Lisence

Distributed under the MIT License. See `LICENSE.md` for more information.
