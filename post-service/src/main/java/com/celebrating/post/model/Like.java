package com.celebrating.post.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import java.time.LocalDateTime;

@Data
@Getter
@Setter
@Table("likes")
public class Like {
    @Id
    private Long id;
    private Long postId;
    private Long userId;
    private LocalDateTime createdAt;
}
