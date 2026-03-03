# CKAD Practice Questions - Lab Setup Scripts

Lab setup scripts for [aravind4799/CKAD-Practice-Questions](https://github.com/aravind4799/CKAD-Practice-Questions).

Each folder contains:
- **setup.sh** - Provisions prerequisite K8s resources so you can start solving immediately
- **QUESTION.md** - The question prompt (no spoilers)
- **ANSWER.md** - The full solution walkthrough

## Usage

Setup a single question: `cd` into the folder and run `./setup.sh`

Or use `./setup-all.sh` to run all, or `./setup-all.sh 1 3 8` for specific ones.

Cleanup with `./cleanup-all.sh`

Note: Some questions share resource names in default namespace (e.g. Q1/Q13 both create api-server). Run independently or cleanup between them.
