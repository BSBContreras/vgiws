"""
This file transform the SQL produced by MySQL on SQL that can execute on PostgreSQL
"""


__READ_SQL_FILE__ = "db_pauliceia_by_msql.sql"

__OUTPUT_SQL_FILE__ = "db_pauliceia_by_postgresql.sql"


pauliceia_way_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.way_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.way_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  version INT NOT NULL,  
  fk_way_id INT NOT NULL,
  fk_way_version INT NOT NULL,
  PRIMARY KEY (id, version, k),
  CONSTRAINT fk_way_tag_way1
    FOREIGN KEY (fk_way_id, fk_way_version)
    REFERENCES pauliceia.way (id, version)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}
pauliceia_node_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.node_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.node_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  version INT NOT NULL,
  fk_node_id INT NOT NULL,
  fk_node_version INT NOT NULL,
  PRIMARY KEY (id, version, k),
  CONSTRAINT fk_node_tag_node1
    FOREIGN KEY (fk_node_id, fk_node_version)
    REFERENCES pauliceia.node (id, version)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}
pauliceia_area_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.area_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.area_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  version INT NOT NULL,
  fk_area_id INT NOT NULL,
  fk_area_version INT NOT NULL,
  PRIMARY KEY (id, version, k),
  CONSTRAINT fk_area_tag_area1
    FOREIGN KEY (fk_area_id, fk_area_version)
    REFERENCES pauliceia.area (id, version)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}


pauliceia_current_way_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.current_way_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.current_way_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  fk_current_way_id INT NOT NULL,
  PRIMARY KEY (id, k),
  CONSTRAINT fk_current_way_tag_current_way1
    FOREIGN KEY (fk_current_way_id)
    REFERENCES pauliceia.current_way (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}
pauliceia_current_node_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.current_node_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.current_node_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  fk_current_node_id INT NOT NULL,
  PRIMARY KEY (id, k),
  CONSTRAINT fk_current_node_tag_current_node1
    FOREIGN KEY (fk_current_node_id)
    REFERENCES pauliceia.current_node (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}
pauliceia_current_area_tag = {
    "create_table_name": "CREATE TABLE IF NOT EXISTS pauliceia.current_area_tag",
    "sql": """
CREATE TABLE IF NOT EXISTS pauliceia.current_area_tag (
  id INT NOT NULL,
  k VARCHAR(255) NOT NULL,
  v VARCHAR(255) NULL,
  fk_current_area_id INT NOT NULL,
  PRIMARY KEY (id, k),
  CONSTRAINT fk_current_area_tag_current_area1
    FOREIGN KEY (fk_current_area_id)
    REFERENCES pauliceia.current_area (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
"""
}

def replace_phrases(text):
    text = text.replace("mydb", "pauliceia")
    text = text.replace("`", "'")
    text = text.replace("TINYINT(1)", "BOOLEAN")
    text = text.replace("ENGINE = InnoDB", "")
    text = text.replace("ON DELETE NO ACTION", "ON DELETE CASCADE")
    text = text.replace("ON UPDATE NO ACTION", "ON UPDATE CASCADE")

    text = text.replace("""SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;""", "")
    text = text.replace("""SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';""", "")

    text = text.replace("-- MySQL Script generated by MySQL Workbench", "")
    text = text.replace("-- Model: New Model    Version: 1.0", "")
    text = text.replace("-- MySQL Workbench Forward Engineering", "")
            
    text = text.replace(")\n;", "\n);")  # put the ) and ; together, and in other line
    text = text.replace("'", "")
    text = text.replace("USE pauliceia ;", "")
    text = text.replace(" DEFAULT CHARACTER SET utf8", "")

    # if the geometries are not in text, so replace them
    if "GEOMETRY(MULTIPOINT, 4326)" not in text:
        text = text.replace("MULTIPOINT", "GEOMETRY(MULTIPOINT, 4326)")
    if "GEOMETRY(MULTILINESTRING, 4326)" not in text:
        text = text.replace("MULTILINESTRING", "GEOMETRY(MULTILINESTRING, 4326)")
    if "GEOMETRY(MULTIPOLYGON, 4326)" not in text:
        text = text.replace("MULTIPOLYGON", "GEOMETRY(MULTIPOLYGON, 4326)")

    return text

def remove_bad_create_tables(text):
    break_loop = False

    while not break_loop:

        if (pauliceia_way_tag["create_table_name"] not in text) and \
                (pauliceia_node_tag["create_table_name"] not in text) and \
                (pauliceia_area_tag["create_table_name"] not in text) and \
                (pauliceia_current_way_tag["create_table_name"] not in text) and \
                (pauliceia_current_node_tag["create_table_name"] not in text) and \
                (pauliceia_current_area_tag["create_table_name"] not in text):

            break_loop = True
            continue

        lines = text.split("\n")            
        lines_copy = list(lines)  # create a copy to iterate inside it

        for a in range(0, len(lines_copy)):            
            line = lines_copy[a]

            # if the create clause is in line, remove the SQL
            if (pauliceia_way_tag["create_table_name"] in line) or \
                (pauliceia_node_tag["create_table_name"] in line) or \
                (pauliceia_area_tag["create_table_name"] in line) or \
                (pauliceia_current_way_tag["create_table_name"] in line) or \
                (pauliceia_current_node_tag["create_table_name"] in line) or \
                (pauliceia_current_area_tag["create_table_name"] in line):

                # find initial_line and final_line
                initial_line = a
                final_line = 0                
                for j in range(initial_line, len(lines_copy)):
                    line_j = lines_copy[j]
                    if ");" in line_j:
                        final_line = j
                        break

                for k in range(final_line, initial_line-1, -1):
                    line_k = lines_copy[k]

                    #print(lines[k])
                    del lines[k]

                lines.insert(initial_line-1, " \n")                    

                break

        text = "\n".join(lines)

    return text

def remove_bad_lines_and_put_default_values(text):
        
    lines = text.split("\n")
    lines_copy = list(lines)  # create a copy to iterate inside it

    # iterate reversed
    for i in range(len(lines_copy)-1, -1, -1):
        line = lines_copy[i]
        # if there is a index line, so remove it in the original list
        line_lower = line.lower()
        if "index" in line_lower or ("brst" in line_lower and "2017" in line_lower):
            del lines[i]
            continue

        # put cascade in the final of line
        if ("drop schema if exists" in line_lower or "drop table if exists" in line_lower) \
            and "cascade" not in line_lower:
            lines[i] = lines[i].replace(";", "CASCADE ;")

        # put default values, but NOT in FKs
        if "visible boolean" in line_lower and "fk" not in line_lower:
            lines[i] = lines[i].replace(",", " DEFAULT TRUE,")
            #print(lines[i])

        if "version int" in line_lower and "fk" not in line_lower:
            lines[i] = lines[i].replace(",", " DEFAULT 1,")
            #print(lines[i])

    text = "\n".join(lines)

    return text

def add_new_lines(text):        
    lines = text.split("\n")
    lines_copy = list(lines)  # create a copy to iterate inside it

    for i in range(0, len(lines_copy)):
        line = lines_copy[i]

        # insert create extension before create schema
        if "CREATE SCHEMA IF NOT EXISTS pauliceia ;" in line:                
            lines.insert(i+2, "CREATE EXTENSION IF NOT EXISTS postgis; \n")
            break 

    text = "\n".join(lines)

    return text

def add_serial_number_in_ID(text):
    lines = text.split("\n")
    lines_copy = list(lines)  # create a copy to iterate inside it

    for i in range(0, len(lines_copy)):
        line = lines_copy[i]

        line_lower = line.lower()

        # put SERIAL just in ID field, NOT in FKs
        if "id int" in line_lower and "fk" not in line_lower:
            line_splited = line.replace("NOT NULL", "").split(" ")
            line_splited[3] = "SERIAL"                
            lines[i] = " ".join(line_splited)

    text = "\n".join(lines)

    return text

def add_create_tables_updated(text):
    text += "\n"+"""
-- -----------------------------------------------------
-- Tables pauliceia.*_tag
-- -----------------------------------------------------
    """
    
    text += pauliceia_way_tag["sql"] + "\n"
    text += pauliceia_node_tag["sql"] + "\n"
    text += pauliceia_area_tag["sql"] + "\n"
    text += pauliceia_current_way_tag["sql"] + "\n"
    text += pauliceia_current_node_tag["sql"] + "\n"
    text += pauliceia_current_area_tag["sql"] + "\n"

    return text

def last_modifications(text):

    # remove the schema
    text = text.replace("pauliceia.", "")

    text = text.replace("""
-- -----------------------------------------------------
-- Schema pauliceia
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS pauliceia CASCADE ;

-- -----------------------------------------------------
-- Schema pauliceia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS pauliceia ;""", "")

    text = text.replace("\n\n\n\n", "\n")

    text = text.replace(" user ", " user_ ")

    return text


def main():
    """
    This function replace code from MySQL generate
    by MySQL Workbench to PostgreSQL SQL
    with some modifications to Pauliceia
    """

    with open(__OUTPUT_SQL_FILE__, 'a') as file_output, open(__READ_SQL_FILE__, 'r') as file_read:
        text = file_read.read() # read everything in the file
        

        text = replace_phrases(text)

        # remove bad create tables
        text = remove_bad_create_tables(text)

        # add create tables updated
        text = add_create_tables_updated(text)
        
        # remove bad lines     
        text = remove_bad_lines_and_put_default_values(text)        

        # add new lines
        #text = add_new_lines(text)

        # add SERIAL number in ID
        text = add_serial_number_in_ID(text)

        text = last_modifications(text)


        # after all modification save it in file again
        
        file_output.seek(0) # rewind (return pointer to top of file)
        file_output.truncate() # clear file
        file_output.write(text) # write the updated text before

        print("All file was changed with sucess!")
       
main()
