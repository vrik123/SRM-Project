<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include "/var/www/inc/dbinfo.inc"; // Ensure the path is correct
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Employee Management</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .container {
      width: 80%;
      margin: auto;
      overflow: hidden;
    }
    header {
      background: #50b3a2;
      color: #fff;
      padding-top: 30px;
      min-height: 70px;
      border-bottom: #e8491d 3px solid;
    }
    header a {
      color: #fff;
      text-decoration: none;
      text-transform: uppercase;
      font-size: 16px;
    }
    header ul {
      padding: 0;
      list-style: none;
    }
    header li {
      float: left;
      display: inline;
      padding: 0 20px 0 20px;
    }
    header #branding {
      float: left;
    }
    header #branding h1 {
      margin: 0;
    }
    header nav {
      float: right;
      margin-top: 10px;
    }
    form {
      background: #fff;
      padding: 20px;
      margin-top: 20px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    table {
      width: 100%;
      margin-top: 20px;
      border-collapse: collapse;
    }
    table, th, td {
      border: 1px solid #ddd;
    }
    th, td {
      padding: 15px;
      text-align: left;
    }
    th {
      background-color: #50b3a2;
      color: white;
    }
  </style>
</head>
<body>
<header>
  <div class="container">
    <div id="branding">
      <h1>Employee Management System</h1>
    </div>
    <nav>
      <ul>
        <li><a href="#">Home</a></li>
      </ul>
    </nav>
  </div>
</header>
<div class="container">
  <?php
  /* Connect to MySQL and select the database. */
  $connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);

  if (mysqli_connect_errno()) {
    echo "<p>Failed to connect to MySQL: " . mysqli_connect_error() . "</p>";
    exit();
  }

  $database = mysqli_select_db($connection, DB_DATABASE);

  if (!$database) {
    echo "<p>Failed to select database: " . mysqli_error($connection) . "</p>";
    exit();
  }

  /* Ensure that the EMPLOYEES table exists. */
  VerifyEmployeesTable($connection, DB_DATABASE);

  /* If input fields are populated, add a row to the EMPLOYEES table. */
  $employee_name = isset($_POST['NAME']) ? htmlentities($_POST['NAME']) : '';
  $employee_address = isset($_POST['ADDRESS']) ? htmlentities($_POST['ADDRESS']) : '';

  if (!empty($employee_name) || !empty($employee_address)) {
    AddEmployee($connection, $employee_name, $employee_address);
  }
  ?>

  <!-- Input form -->
  <form action="<?php echo htmlspecialchars($_SERVER['SCRIPT_NAME']); ?>" method="POST">
    <table>
      <tr>
        <th>NAME</th>
        <th>ADDRESS</th>
      </tr>
      <tr>
        <td>
          <input type="text" name="NAME" maxlength="45" size="30" />
        </td>
        <td>
          <input type="text" name="ADDRESS" maxlength="90" size="60" />
        </td>
        <td>
          <input type="submit" value="Add Data" />
        </td>
      </tr>
    </table>
  </form>

  <!-- Display table data -->
  <table>
    <tr>
      <th>ID</th>
      <th>NAME</th>
      <th>ADDRESS</th>
    </tr>
    <?php
    $result = mysqli_query($connection, "SELECT * FROM EMPLOYEES");

    if (!$result) {
      echo "<tr><td colspan='3'>Error fetching data: " . mysqli_error($connection) . "</td></tr>";
      exit();
    }

    while ($query_data = mysqli_fetch_row($result)) {
      echo "<tr>";
      echo "<td>", $query_data[0], "</td>",
           "<td>", $query_data[1], "</td>",
           "<td>", $query_data[2], "</td>";
      echo "</tr>";
    }
    ?>
  </table>

  <!-- Clean up -->
  <?php
  mysqli_free_result($result);
  mysqli_close($connection);
  ?>
</div>
</body>
</html>

<?php
/* Add an employee to the table */
function AddEmployee($connection, $name, $address) {
  $n = mysqli_real_escape_string($connection, $name);
  $a = mysqli_real_escape_string($connection, $address);

  $query = "INSERT INTO EMPLOYEES (NAME, ADDRESS) VALUES ('$n', '$a');";

  if (!mysqli_query($connection, $query)) {
    echo "<p>Error adding employee data: " . mysqli_error($connection) . "</p>";
  }
}

/* Check whether the table exists and, if not, create it */
function VerifyEmployeesTable($connection, $dbName) {
  if (!TableExists("EMPLOYEES", $connection, $dbName)) {
    $query = "CREATE TABLE EMPLOYEES (
      ID int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      NAME VARCHAR(45),
      ADDRESS VARCHAR(90)
    )";

    if (!mysqli_query($connection, $query)) {
      echo "<p>Error creating table: " . mysqli_error($connection) . "</p>";
    }
  }
}

/* Check for the existence of a table */
function TableExists($tableName, $connection, $dbName) {
  $t = mysqli_real_escape_string($connection, $tableName);
  $d = mysqli_real_escape_string($connection, $dbName);

  $checktable = mysqli_query($connection,
    "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$t' AND TABLE_SCHEMA = '$d'");

  if (mysqli_num_rows($checktable) > 0) return true;

  return false;
}
?>
