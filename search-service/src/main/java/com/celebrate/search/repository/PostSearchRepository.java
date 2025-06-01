package com.celebrate.search.repository;

import com.celebrate.search.model.SearchablePost;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PostSearchRepository extends ElasticsearchRepository<SearchablePost, String> {
    List<SearchablePost> findByTitleContainingOrContentContaining(String title, String content);
    List<SearchablePost> findByCategory(String category);
    List<SearchablePost> findByUserId(String userId);
} 