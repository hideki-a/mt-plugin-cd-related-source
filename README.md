# リンク元コンテンツデータ取得プラグイン

## 概要

あるコンテンツデータにおいて自身を参照しているコンテンツデータを取得するブロックタグ`MTCDRelatedSources`を提供します。  
Movable Type 7用です。

## 解説

「セミナー」コンテンツタイプの「登壇講師」フィールドは、[コンテンツタイプフィールド](https://www.movabletype.jp/documentation/mt7/designers-guide/designing-content-type/available-field-types/content-type.html)を用いて「講師」コンテンツタイプのデータを選択してリンクしているとします。  
この前提において、「講師」コンテンツタイプの各講師データを出力する時に、セミナー名称等「セミナー」コンテンツタイプのデータを容易に出力可能にする（コンテンツデータの逆引きを可能にする）タグを提供します。

### テンプレートタグ記述例

※「セミナー」コンテンツタイプの「登壇講師」フィールドのIDは`35`とします。

```html
<mt:Contents content_type="講師">
  <mt:ContentsHeader><div class="seminar"></mt:ContentsHeader>
  <h3><mt:ContentField content_field="氏名"><mt:ContentFieldValue escape /></mt:ContentField></h3>
  <dl>
    <div>
      <dt>担当セミナー</dt>
      <dd>
        <mt:ContentID setvar="speaker_id" />
        <mt:CDRelatedSources field_name="登壇講師" related_id="$speaker_id">
          <mt:If name="__first__"><ul></mt:If>
          <li><mt:ContentField content_field="セミナー名称"><mt:ContentFieldValue escape /></mt:ContentField></li>
          <mt:If name="__last__"></ul></mt:If>
        </mt:CDRelatedSources>
      </dd>
    </div>
  </dl>
  <mt:ContentsFooter></div></mt:ContentsFooter>
</mt:Contents>
```
もしくは

```html
<mt:Contents content_type="講師">
  <mt:ContentsHeader><div class="seminar"></mt:ContentsHeader>
  <h3><mt:ContentField content_field="氏名"><mt:ContentFieldValue escape /></mt:ContentField></h3>
  <dl>
    <div>
      <dt>担当セミナー</dt>
      <dd>
        <mt:ContentID setvar="speaker_id" />
        <mt:CDRelatedSources field_id="35" related_id="$speaker_id">
          <mt:If name="__first__"><ul></mt:If>
          <li><mt:ContentField content_field="セミナー名称"><mt:ContentFieldValue escape /></mt:ContentField></li>
          <mt:If name="__last__"></ul></mt:If>
        </mt:CDRelatedSources>
      </dd>
    </div>
  </dl>
  <mt:ContentsFooter></div></mt:ContentsFooter>
</mt:Contents>
```

#### 参考：セミナーコンテンツタイプのテンプレート記述

```html
<mt:Contents content_type="セミナー">
  <mt:ContentsHeader><div class="seminar"></mt:ContentsHeader>
  <h3><mt:ContentField content_field="セミナー名称"><mt:ContentFieldValue escape /></mt:ContentField></h3>
  <dl>
    <div>
      <dt>講師</dt>
      <dd>
        <mt:ContentField content_field="登壇講師">
          <mt:If name="__first__"><ul></mt:If>
          <li><mt:ContentField content_field="氏名"><mt:ContentFieldValue escape /></mt:ContentField></li>
          <mt:If name="__last__"></ul></mt:If>
        </mt:ContentField>
      </dd>
    </div>
  </dl>
  <mt:ContentsFooter></div></mt:ContentsFooter>
</mt:Contents>
```
