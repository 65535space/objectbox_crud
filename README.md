# objectbox_demo
objectboxを扱う方法
参考文献
https://docs.objectbox.io/tutorial-demo-project
1. 以下をターミナルで実行
flutter pub add objectbox objectbox_flutter_libs path_provider path

flutter pub add --dev build_runner objectbox_generator

3. モデルクラスの設計
@Entityをもつクラスをつくる

4. flutter pub run build_runner build

## ODBMSとRDBMSの違い(オブジェクトデータベースとリレーショナルデータベースの違い)
#### データモデル
ODBMS:データはオブジェクトとして保存される
RDBMS:データをテーブル形式で管理

#### データの扱い

ODBMS:複雑なオブジェクトの階層や関係を直接扱う
RDBMS:標準化された方法で大量のデータを効率的に管理する

例(ODBMS)
```java
class Employee {
    String name;
    int id;
    List<Project> projects;
    
    // コンストラクタ、メソッドなど
}

class Project {
    String projectName;
    int projectId;
    
    // コンストラクタ、メソッドなど
}

// データベースに保存
Employee emp = new Employee("Alice", 1);
emp.projects.add(new Project("Project X", 101));
odbms.save(emp);
```

例(RDBMS)
```sql
-- 社員テーブル
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- プロジェクトテーブル
CREATE TABLE Project (
    projectId INT PRIMARY KEY,
    projectName VARCHAR(50)
);

-- 社員とプロジェクトの関連テーブル
CREATE TABLE Employee_Project (
    employeeId INT,
    projectId INT,
    FOREIGN KEY (employeeId) REFERENCES Employee(id),
    FOREIGN KEY (projectId) REFERENCES Project(projectId)
);

-- データの挿入
INSERT INTO Employee (id, name) VALUES (1, 'Alice');
INSERT INTO Project (projectId, projectName) VALUES (101, 'Project X');
INSERT INTO Employee_Project (employeeId, projectId) VALUES (1, 101);
```
# objectbox_crud
