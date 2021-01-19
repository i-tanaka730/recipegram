# 2020/12/4 時点のRuby最新バージョン
FROM ruby:2.7.2

# 必要なパッケージのインストール(Railseでは以下のセットが必要らしい)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn \
    && mkdir /recipegram

# 作業ディレクトリの作成、設定
WORKDIR /recipegram

# ホスト側（ローカル）のGemfileを追加する（ローカルのGemfileは【３】で作成）
COPY Gemfile /recipegram/Gemfile
COPY Gemfile.lock /recipegram/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
COPY . /recipegram
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]