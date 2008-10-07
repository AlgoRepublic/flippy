package com.flippy.domain;

import java.util.Date;

/**
 * @author uudashr
 *
 */
public class Room {
    private int id;
    private String name;
    private int learningAge;
    private String description;
    private Date dateCreate;
    
    public Room() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLearningAge() {
        return learningAge;
    }

    public void setLearningAge(int learningAge) {
        this.learningAge = learningAge;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getDateCreate() {
        return dateCreate;
    }
    
    public void setDateCreate(Date dateCreate) {
        this.dateCreate = dateCreate;
    }
}
