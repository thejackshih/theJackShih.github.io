title: No Fragment ， One Activity - Custom View 架構
date: 2016-05-24 17:11:34
tags: android
---
# 前言

近期在接觸 Fragment 時，看見了 Square 工程師寫的反 Fragment 文章，在文章中也提出了新的做法，也就是用 Custom View 取代 Fragment 。文章對 Android 新手來說並不好懂，至少對我來說是這樣。多看幾遍之後，再搭配 Youtube 上，有高手在 JCConf 上介紹此架構的影片。應該是多少掌握了一些。在這裡簡單寫一下心得。

<!-- more -->

# 架構

基本上這個架構就是沿用 One Activity - Multiple Fragments 的架構，只是將 Fragment 用 Custom View 取代，不用 Fragment 的理由在Square文章及 JCConf 影片中都已經敘述很清楚。在這裡就不贅述了，自己並沒有很深入的用過 Fragment 所以沒什麼體會，頂多就是 Fragment 那看起來很恐怖的 Life cycle 吧。 Fragment 的高度複雜度讓 Google 在最近的 Google I/O 2016 上還開了一門專題專門在介紹 Fragment 的來龍去脈。

架構上由單一 Activity 內裝一個名叫 Container 的 Custom View ，由 Container 抽換各種 View。

# 範例

原本想直接用 Square 的範例，不過用 LiveView 不夠傻瓜。
這裡做一個在主畫面可以輸入名字，按下按鈕之後就可以跟你說 Hello 的 App 。

# Activity

Activity要做的事情很簡單

處理返回事件：由於不再依賴 Fragment ，原本由Fragment代勞的返回鍵處理必須要自己來。
建立存取 Container 的管道：建立存取 View 容器的管道。
跟 Square 範例完全一樣

{% codeblock MainActivity.java lang:java %}
public class MainActivity extends Activity {
    private Container container;

    @Override protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        container = (Container) findViewById(R.id.container);
    }
    @Override public void onBackPressed() {
        boolean handled = container.onBackPressed();
        if(!handled) {
            finish();
        }
    }
    public Container getContainer() {
        return container;
    }
}
{% endcodeblock %}

建構式建立 View 並取得其中的 container 。
在 onBackPressed() 中首先呼叫 container 的 onBackPressed 方法，並由 Container 回傳這個返回鍵是否是結束 App 的返回鍵。如果是結束 App 的返回鍵則呼叫 finish() 關閉這個 App.
 的 layout 也很簡單，就是把 Container 放進去。

{% codeblock res/layout/main_activity.xml lang:xml %}
<com.rdize.nofragmentexample.SinglePaneContainer
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_margin="16dp"
    android:id="@+id/container">
</com.rdize.nofragmentexample.SinglePaneContainer>
{% endcodeblock %}

再來是 Container

# Container

Container 要做的事情有

1. 控制目前要顯示哪個畫面：因為會切換畫面 ，所以 Container 要做的事情就是在要切換畫面時，移除目前的 View ，插入新的 View。
2. 處理返回鍵事件： 當使用者按下返回鍵時， 移除目前的 View ，插入上一個 View
3. 判斷是否這是 Root View： 可以告訴 Activity 是不是該關閉App了。

在 Square 的範例中要展示支援平板，所以把 Container 抽象成一個介面，不過這樣也比較清楚。

{% codeblock container.java lang:java %}
public interface Container {
    void showName(String name);
    boolean onBackPressed();
}
{% endcodeblock %}

showName 做的是切換 View 並顯示輸入的名字。
onBackPressed 就是移除 View 並回傳是否已經是 root view 了。

Square 的範例將首頁嵌入 Container 中讓程式碼比較單純，這裡用比較通用的做法。

{% codeblock SinglePaneContainer.java lang:java %}
public class SinglePaneContainer extends LinearLayout implements Container {
    MainView mainView;

    public SinglePaneContainer(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override protected void onFinishInflate() {
        super.onFinishInflate();
        View.inflate(getContext(), R.layout.main_view, this);
        mainView = (MainView) getChildAt(0);
    }

    @Override public boolean onBackPressed() {
        if(!rootViewAttached()) {
            removeViewAt(0);
            addView(mainView);
            return true;
        }
        return false;
    }

    @Override public void showName(String name) {
        TransitionManager.beginDelayedTransition(this);
        if(rootViewAttached()) {
            removeViewAt(0);
            View.inflate(getContext(), R.layout.hello_view, this);
        }
        HelloView helloView = (HelloView) getChildAt(0);
        helloView.setMessage(name);
    }
    private boolean rootViewAttached() {
        return mainView.getParent() != null;
    }
}
{% endcodeblock %}

SinglePaneContainer 繼承 LinearLayout 所以也是一個 CustomView。除了CustomView要做的事情外還要處理 Container 該做的。

onFinishInflate 方法，在 super.onFinishInflate 後就可以存取這個 CustomView 內的 View 了。在這裡將首頁 MainView 先建立起來。由於 Container 內只會有 View 也就是目前的畫面，所以可以很確定的使用 getChildAt(0) 將目前的畫面取出。

onBackPressed 同理，removeViewAt(0) 就可以將當前畫面移除。如果是跟rootview，就直接回傳false讓Activity做關閉app的動作，否則就把當前View移除，並將rootView加回來。

rootViewAttached 是因為這裡使用單純兩層式架構(只有兩個View)，所以可以直接用getParent()來判斷是否已經是rootView。

showName 跟 onBackPressed 一樣，移除當前的 View 並插入新的 View 。跟前面一樣因為只會有一個 View 所以用 getChildAt(0) 就可以取出，接著可以對 View 做一些設定。另外加上一行
TransitionManager.beginDelayedTransition(this); 就可以用漂亮的轉場效果了真好。

# CustomView

在 Container 中的 R.layout.main_view 跟 R.layout.hello_view 做法一樣，用 CustomView 把想要呈現的畫面包起來。

{% codeblock res/layout/main_view.xml lang:xml %}
<com.rdize.nofragmentexample.MainView
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical" android:layout_width="match_parent"
    android:layout_height="match_parent">
    <EditText
        android:id="@+id/main_view_edittext"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />
    <Button
        android:id="@+id/main_view_button"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Button"/>
</com.rdize.nofragmentexample.MainView>
{% endcodeblock %}

CustomView 雖然也有很多東西要學，但這裡只需要知道兩件事情就好

1. 建構式傳入 Context 與 AttributeSet。
2. 在 onFinishInflate 方法後可以存取 CustomView 中的 View。

MainView 的程式碼如下

{% codeblock MainView.java %}
public class MainView extends LinearLayout {
    Button button;
    public MainView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override protected void onFinishInflate() {
        super.onFinishInflate();
        button = (Button) findViewById(R.id.main_view_button);
        button.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity mainActivity = (MainActivity) getContext();
                EditText name = (EditText) findViewById(R.id.main_view_edittext);
                mainActivity.getContainer().showName(name.getText().toString());
            }
        });
    }
}
{% endcodeblock %}

由於是單一 Activity 配 Container ，所以可以只要用 getContext() 就可拿到 Activity。

而 HelloView 也一樣在先在 layout 用 CustomView 把要呈現的畫面包起來。

{% codeblock res/layout/hello_view.xml lang:java %}
<com.rdize.nofragmentexample.HelloView
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    >
    <TextView
        android:id="@+id/hello_view_welcome_message"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />
</com.rdize.nofragmentexample.HelloView>
{% endcodeblock %}

然後在照著前面的方法完成 CustomView

{% codeblock HelloView.java lang:java %}
public class HelloView extends LinearLayout {
    TextView welcomeMessage;

    public HelloView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override protected void onFinishInflate() {
        super.onFinishInflate();
        welcomeMessage = (TextView) findViewById(R.id.hello_view_welcome_message);
    }

    public void setMessage(String name) {
        String message = "Hello " + name;
        welcomeMessage.setText(message);
    }
}
{% endcodeblock %}

# 後記

這樣的做法跟 Fragment 比起來看起來是簡單許多，甚至比最初的 Multiple Activities 架構還要簡單，要做到在不同 View 傳值也比較容易，甚至要在各個 View 共用值也是可以。不需要為了簡單的功能使用很複雜的 API，另外還有一個優點是擺脫 API 版本的相依，因為只有用到最基本的 View API 而已。

#延伸

以上只是簡陋的範例，可以繼續改進的有幾點。

## 通用化

在 Container interface 的定義是針對範例所設計，要用在更廣泛的地方也許要將 showName 改為 addView 之類的做法會更恰當。

## MVP

在 Square 文章的範例中有示範如何進一步將 CustomView 中的邏輯部分分割出來成為 Presenter ， 讓程式碼更清楚。

## BackStack 管理

範例只有兩個 View ，而且深度也不深，實務上會有更多的 View 深度也會很深(一個畫面接著一個畫面) 這時候從哪裡來就是一件要處理的事情了， Square 寫了一個 flow 專門做這件事情，如果不想要把搞太複雜也可以自己處理。

# github

[noFragmentExample](https://github.com/randomdize/noFragmentExample)

# Reference

[Advocating Against Android Fragments](https://corner.squareup.com/2014/10/advocating-against-android-fragments.html) - (英文) 原 Square 文章
[[JCConf 2015] Android One Activity, No fragment 架構 by Nevin - R2 Day2-2](https://www.youtube.com/watch?v=soQq4PWHzKc) - (中文)
