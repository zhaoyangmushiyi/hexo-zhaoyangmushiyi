---
title: Git开发规范
date: 2019-12-20 10:23:05
tags:
    - Git
categories:
    - Git
---

### 分支介绍及命名规则

#### **master 分支**

- master 为主分支，也是用于部署生产环境的分支，一定要确保master分支稳定性
- master 分支一般从develop或bugfix分支合并，任何时间都不能直接修改master分支的代码

#### **develop 分支**

- develop 为开发分支，始终保持最新完成以及bug修复后的代码，
- 一般开发的新功能时，feature分支都是基于develop分支下创建的

#### **feature 分支**

- feature 为开发新功能时创建的分支，并且一般是由develop为基础来创建feature分支
- 分支命名: feature/ 开头的为特性分支， 命名示例: feature/user_module、 feature/vacation_plan_module

<!-- more -->

#### **release 分支**

- release 为预上线分支，发布提测阶段，会以release分支代码为基准提测，因为项目组实际情况，人数不够的情况下可以不需要此分支。

#### **bugfix 分支**

- bugfix 为修复分支，它的命名规则与 feature 分支类似，例如bugfix/xxx
- 线上出现紧急问题时，需要及时修复，以master或develop分支为基线，创建bugfix分支，修复完成后，需要合并到master分支和develop分支

### 操作步骤及命令

#### 管理员「项目负责人」创建master及develop分支

一般master分支在创建项目是会默认创建，现在只需要创建develop分支

```shell
git checkout -b develop #git checkout命令加上-b参数表示创建并切换，相当于git branch develop与git checkout develop
```

用`git branch`命令查看当前分支，命令会列出所有分支，当前分支前面会标一个`*`号。

```shell
$ git branch
* develop
  master
```

#### 项目成员「开发者」clone 项目，在本地建立自己的功能分支

```shell
git clone <项目 git 地址>
git checkout -b develop origin/develop

#创建本地功能分支
git checkout -b feature/[feature-name] develop
```

在自己的本地feature分支上进行开发 ： `git add` ，`git commit` 等，注意此时不要 push 到远程分支（origin）。

功能完成后可以直接合并本地的 `feature` 分支到本地的 `develop` 分支后 push 到远程仓库，合并的时候很大几率发生冲突，此时需要 `merge` ，`merge` 的时候确保不影响项目其他成员，如果多个人都操作了同一个类，最好当面确认后在进行修改。等合并完成确认无误后，删除本地开发分支

```shell
git checkout develop 
git pull origin develop #确保本地 developer 分支为最新的
git merge feature/[feature-name] #合并本地的 `feature` 分支到本地的 `develop` 分支
git push #确保你当前在develop分支下面push
git branch -d feature/[feature-name] #删除本地分支
```

#### 发布分支

```shell
git checkout -b release-0.1 develop #从develop分支迁出预发布分支

#一旦准备好了发版，合并修改到 master 分支和 developer 分支上，删除发布分支
#合并修改到 master 分支
git checkout master 
git merge release-0.1 
git push 

#合并修改到 develop 分支
git checkout develop 
git merge release-0.1 
git push 

#删除发布分支
git branch -d release-0.1
```

#### 为 master 分支打发版 tag

```shell
git checkout master 
git tag -a 0.1 -m "Initial public release" master
git push --tags
```

#### 修复 bug 

如果正在开发功能的同时，发现了线上 bug，或者未上线的 bug，我们可以开一个 bugfix 分支来修复 bug，然后将修复后的代码发布到线上以及正在开发的分支上

```shell
git checkout -b bugfix/[bug-name] master（或 develop）

# when fixed bug，合并修改好的代码到master以及develop分支
git checkout master
git merge bugfix/[bug-name]
git checkout develop
git merge bugfix/[bug-name]

git push
git branch -d bugfix/[bug-name]
```

#### 特别提示

项目中存在很多配置文件，不同分支配置文件可能不同，因此在merge时需要忽略配置文件合并

1. 首先，需要创建自定义的 `merge driver`

   ```shell
   git config --global merge.ours.driver true
   ```

2. 在要被`merge`的分支上创建`.gitattributes`文件,并且在文件中置顶不`merge`的文件名

   ```shell
   echo 'Jenkinsfile merge=ours' >> .gitattributes
   git add .gitattributes
   git commit -m 'chore: Preserve Jenkinsfile during merges'
   ```

3. 回到要合并到的分支`master`,执行`merge`

   ```shell
   git checkout master
   git merge xxxx
   ```

PS：只能`master`合并`其他分支`时忽略`其他分支`上的文件, `其他分支`合并`master`无法忽略`master`上的文件