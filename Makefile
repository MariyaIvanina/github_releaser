VENV_PATH?=/venv
PYTHON=${VENV_PATH}/bin/python3

.PHONY: build-release venv release install-dependencies

install-dependencies: requirements.txt
	test -d $(VENV_PATH) || virtualenv -p python3 $(VENV_PATH)
	$(VENV_PATH)/bin/pip install --no-cache-dir -r requirements.txt
	touch $(VENV_PATH)/bin/activate

venv: 
	touch $(VENV_PATH)/bin/activate

release: install-dependencies
	git config --global user.email "example@gmail.com"                                                                            
	git config --global user.name "Example"
	${PYTHON} -m bumpversion --new-version ${v} build --tag --tag-name "v${v}" --allow-dirty
	${PYTHON} -m bumpversion patch --no-tag --allow-dirty
	git remote set-url origin https://example:${githubtoken}@github.com/MariyaIvanina/github_releaser
	git push origin master "v${v}"
	git checkout develop
	git merge master
	git push origin develop

build-release: venv
	${PYTHON} -m bumpversion --new-version ${v} build --no-commit --no-tag --allow-dirty

