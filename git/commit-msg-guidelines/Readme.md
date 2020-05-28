# Commit message hook

## Setup instructions

1.  Go to git local repository
```bash
cd /path/to/the/git/local/repository
```

2.  Setup commit-msg hook
```bash
rm -rf /tmp/setup && \
    wget https://raw.githubusercontent.com/rxmicro/dev/master/git/commit-msg-guidelines/setup.sh -O /tmp/setup && \
    chmod 755 /tmp/setup && \
    /tmp/setup 
```

## The seven rules of a great Git commit message

1. Separate subject from body with a blank line!
2. Limit the subject line to 50 characters!
3. Capitalize the subject line!
4. Do not end the subject line with a period!
5. Use the imperative mood in the subject line!
    
    *A properly formed Git commit subject line should always be able to complete the following sentence:* 
    
    `If applied, this commit will <your-subject-line-here>`
    
6. Wrap the body at 72 characters!
7. Use the body to explain what and why (not how!)!

## Read more: 

* [How to Write a Git Commit Message.](https://chris.beams.io/posts/git-commit/)
* [Customizing Git via Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)