Zenrei is a service that can search the use history of class name, method name, and variable name from GitHub's most starred repositories.

GitHubのスター数上位のリポジトリから，クラス名・メソッド名・変数名の使用実績を検索できるサービスです．

## Usage

### Web

Available at [https://zenrei.nyamikan.net/](https://zenrei.nyamikan.net/)

### API

#### /v1/search

Returns use places of the specified name.

```
$ curl https://zenrei.nyamikan.net/v1/search?q=test_method
{
  "test_method": [
    {
      "Repository": "oracle/truffleruby",
      "Filename": "tool/parse_mri_errors.rb",
      "Type": 31,
      "Name": "test_method"
    },
    {
      "Repository": "ruby/ruby",
      "Filename": "sample/simple-bench.rb",
      "Type": 30,
      "Name": "test_methods"
    }
  ]
}
```

Parameter | Type | Description
--|--|--
q|string|name (case sensitive, forward match)

Key | Type | Description
--|--|--
Repository | String | repository name
Filename | String | file path in repository
Type | Number | name type<br>10: class<br>11: module<br>20: method<br>30: variable<br>31: parameter<br>32: instance variable<br>33: global variable<br>34: class variable
Name | String | class/method/variable name

#### /v1/suggest

Returns the usage frequencies of the specified name.

```
$ curl https://zenrei.nyamikan.net/v1/suggest?q=ssl_context
[
  {
    "Name": "ssl_context",
    "Type": 0,
    "Count": 42
  },
  {
    "Name": "ssl_context_without_verify",
    "Type": 0,
    "Count": 2
  },
  {
    "Name": "ssl_context_with_verify",
    "Type": 0,
    "Count": 2
  }
]
```

Parameter | Type | Description
--|--|--
q|string|name (case insensitive, forward match)

Key | Type | Description
--|--|--
Name | String | class/method/variable name
Type | Number | name type (unused)
Count | Number | number of use

#### /v1/synonym

Returns the synonyms of the specified name.

```
$ curl https://zenrei.nyamikan.net/v1/synonym?q=estimated
[
  {
    "Synset": "05803379-n",
    "Lang": "eng",
    "Name": "estimation"
  },
  {
    "Synset": "05803379-n",
    "Lang": "eng",
    "Name": "estimate"
  },
  {
    "Synset": "05803379-n",
    "Lang": "jpn",
    "Name": "見積り"
  },
  {
    "Synset": "05803379-n",
    "Lang": "jpn",
    "Name": "値踏み"
  }
]
```

Parameter | Type | Description
--|--|--
q|string|name (will be converted to lemma)

Key | Type | Description
--|--|--
Synset | String | synonym group name
Lang | String | language ("eng" or "jpn")
Name | String | synonym name

## Install

API server

1. Download `wnjpn.db`(Japanese WordNet and English WordNet in an sqlite3 database) from http://compling.hss.ntu.edu.sg/wnja/ to `api/`
1. Rename `mongo/mongod.conf.example` to `mongo/mongod.conf`
2. Rename `database.yml.example` to `database.yml` (used by scripts in `creator/`)
3. Start servers: Run `docker-compose up`
4. Create collections: Run `creator/retreiver.rb`, `creator/parser.rb` and `creator/indexer.rb` with bundler.
5. Try access: http://localhost:8080/v1/search?q=test

View server (for development)

1. Change URL in `view/src/components/SearchBar.vue` (prefix `http://localhost:8080/`)
2. Change directory to `view/`
3. Run `npm run serve`
4. Try access: http://localhost:8081/

