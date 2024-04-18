# myros

My settings for ROS development.

## Setup

1. Install zsh

```bash
$ sudo apt install zsh
```

2. Install prezto and p10k theme

- Follow the instructions on the [prezto github page](https://github.com/sorin-ionescu/prezto).
- Install the p10k theme by following the instructions on the [p10k github page](https://github.com/romkatv/powerlevel10k).

After installing prezto and p10k and run zsh, you should see the p10k configuration wizard. You need to answer the questions, but they will be overwritten by the configuration in this repository next step.

3. Clone this repository and run setup.sh

```bash
$ git clone https://github.com/itadera/myros.git
$ cd myros
$ ./setup.sh
```

4. Reopen your terminal

Then, you should be able to use ```myros``` command.

