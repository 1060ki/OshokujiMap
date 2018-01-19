# 開発環境
- Ruby 2.4.2
- Ruby on Rails 5.1.4
- SQLite3

# 環境構築
1. GitからCloneする

```
$ git clone git@github.com:1060ki/OshokujiMap.git
```

もしくは

```
$ git clone https://github.com/1060ki/OshokujiMap.git
```

2. bundle installする

```
$ bundle install -j4 --path=vendor/bundle
```

3. db:migrateする

```
$ bundle exec rake db:migrate
```

4. yarn addする

```
$ yarn add
```