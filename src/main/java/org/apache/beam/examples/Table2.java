package org.apache.beam.examples;

import java.io.Serializable;
import java.util.UUID;
import java.util.Date;

import com.datastax.driver.mapping.annotations.Column;
import com.datastax.driver.mapping.annotations.PartitionKey;
import com.datastax.driver.mapping.annotations.Table;

@Table(keyspace = "test", name = "table2", readConsistency = "ONE", writeConsistency = "ONE", caseSensitiveKeyspace = false, caseSensitiveTable = false)
public class Table2 implements Serializable {
	private static final long serialVersionUID = 1L;

	@PartitionKey
	@Column(name = "data")
	public String data;

	@Column(name = "an_id")
	public UUID an_id;

	@Column(name = "my_date")
	public Date my_date;

	public Table2() {
	}

	public Table2(String data, UUID an_id) {
		this.data = data;
		this.an_id = an_id;
		this.my_date=new Date();
	}

	@Override
	public boolean equals(Object obj) {
		Table2 other = (Table2) obj;
		return this.data.equals(other.data) && this.an_id.equals(other.an_id) && this.my_date.equals(other.my_date);
	}
}
