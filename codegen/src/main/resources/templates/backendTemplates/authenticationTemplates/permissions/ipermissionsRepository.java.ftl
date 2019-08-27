package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.PermissionEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "permission", path = "permission")
public interface IPermissionRepository extends JpaRepository<PermissionEntity, Long>, QuerydslPredicateExecutor<PermissionEntity> {

    @Query("select u from PermissionEntity u where u.name = ?1")
    PermissionEntity findByPermissionName(String value);
}
