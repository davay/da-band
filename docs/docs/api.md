## Status

## Development

We use Conda to manage the dependencies. Why not Poetry? Personal preference, because for certain packages that has non-Python dependencies, Conda will handle it while Poetry can't, so I got in the habit of using Conda everywhere.

### Dependencies

```
brew install --cask miniconda docker
brew install docker-compose
```

### Quick Start

Make sure your docker is running. 

```
./start.sh
```
