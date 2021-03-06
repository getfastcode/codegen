package [=PackageName].domain.IRepository;

import [=PackageName].domain.Flowable.Users.ActIdUserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;

@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "actIdUser", path = "actIdUser")
public interface IActIdUserRepository extends JpaRepository<ActIdUserEntity, String>, QuerydslPredicateExecutor<ActIdUserEntity> {
    
    @Query("select u from ActIdUserEntity u where u.id = ?1")
    ActIdUserEntity findByUserId(String id);

    @Query("select u from ActIdUserEntity u where u.email = ?1")
    ActIdUserEntity findByUserEmail(String value);
    }